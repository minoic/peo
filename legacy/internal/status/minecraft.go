package status

import (
	"bufio"
	"bytes"
	"context"
	"encoding/binary"
	"encoding/json"
	"errors"
	"io"
	"net"
	"strconv"
	"time"
)

const (
	protocolVersion = 0x47
)

type Pong struct {
	Version struct {
		Name     string `json:"name"`
		Protocol int    `json:"protocol"`
	} `json:"version"`
	Players struct {
		Max    int `json:"max"`
		Online int `json:"online"`
		Sample []struct {
			Name string `json:"name"`
			ID   string `json:"id"`
		} `json:"sample"`
	} `json:"players"`
	Description struct {
		Text      string `json:"text"`
		Translate string `json:"translate"`
		Des       string `json:"-"`
	} `json:"description,omitempty"`
	FavIcon string `json:"favicon"`
	ModInfo struct {
		ModType string `json:"type"`
		ModList []struct {
			ModID      string `json:"modid"`
			ModVersion string `json:"version"`
		} `json:"modList"`
	} `json:"modinfo"`
}

func Ping(host string) (*Pong, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	retc := make(chan *Pong)
	errc := make(chan error)
	go func(ctx context.Context) {
		defer cancel()
		conn, err := net.Dial("tcp", host)
		if err != nil {
			errc <- err
			return
		}
		defer conn.Close()
		if err := sendHandshake(conn, host); err != nil {
			errc <- err
			return
		}
		if err := sendStatusRequest(conn); err != nil {
			errc <- err
			return
		}
		p, err := readPong(conn)
		// glg.Debug(Pong.FavIcon)
		if err != nil {
			// glg.Error(err)
			errc <- err
			return
		}
		if p.FavIcon == "" {
			p.FavIcon = "data:image/png;base64,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8xjws0gCxy+ghmGT+CSytn8tsgRcrbpBdUEF4GT2Af+GYUpy69aFDWEVmeK/DgkQu40ZFtdcVFQANucEkpLcOmd4wTmALOWuA96DLPGUTWirCTgJxd7wbcho8j7UMKwje4D/gUzxn6m6MYuCzgAm427UMKwbX0G28K5BYj2080+ACsDOGDcMH6u6QS3kDqS45quQIJ4TVTdoEVEBOD3KhuF7gS9X3aCG0wX+L/B65NScPwSyqhu1yKgATIdV5NCTwjDUCMPpchiptHM98OPIUkyZAmoCTpeMoWFY1DC8BViuumELypPAbyDi+lTVjWkiOgOYHUUNwyKdtPVRZxPwABKefQ3wYbTzzwwVgNnzCPABNCV5O3wOKa75SqQIR6Wn5rQBFYD5sY9hDcO/g0YYFvSBP0AKa74FKa6ZVt2otqACMH9OAP8LMQxvAD5VdYMq4iiSkfcKxCeZy3HYyihqAlbHeA3D9wE/CixV3bAZ8zQSsfebwLerbkzb0RlAPShHGDbVMHwY+PtI8NQvo52/FqgA1Itxw3BP1Q2aAncCfwPZw/915MBMpSaoANSTwjC8FjEMFy3CMEWi9N4C/ADweyzgqTltQAWg3qwwNAxvpP6G4XEkLv9VSJx+7Y7DVkZRAVgMMqR+4duQctW/Rb3KVT+DBOxch2Tm/UXVDVK2hwrA4vFnSF2766g+JfkR4B8jxt4HaYZn0SpUABaXR5CU5JcB/5z5dr4vAn8T8Sj+E3Co6jdD2RkqAIvPfuTQyuuAv83sIgwdsgx5K/D9wO8A61W/eOX0UAFoDseB/w28hukahiv5dQsjcqGPw1ZGUQFoHmXD8I1IZdydGIb7gX+N7N/PcmahVIgKQLO5C6mMez3bjzB8DPg5xNj7Z2j2YqNRAWgH30AiDF8O/CIbG4b3IEFH1yLn5TUxHFkZQ5OB2sV+4CNIea13Az+DhOb+GlLGzFXdQGW+GO/1sBRFaSu6BFCUFqMCoCgtRgVAUVqMCoCitBgVAEVpMSoAitJiVAAUpcWoAChKi1EBUJQWowKgKC1GBUBRWsz/B0SPFnvBXwUbAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDE5LTEyLTI4VDA5OjMxOjU2KzAwOjAwuGsTuQAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxOS0wMS0wOFQxOTozOTozNSswMDowMKJkNLUAAAAgdEVYdHNvZnR3YXJlAGh0dHBzOi8vaW1hZ2VtYWdpY2sub3JnvM8dnQAAABh0RVh0VGh1bWI6OkRvY3VtZW50OjpQYWdlcwAxp/+7LwAAABh0RVh0VGh1bWI6OkltYWdlOjpIZWlnaHQAMjU26cNEGQAAABd0RVh0VGh1bWI6OkltYWdlOjpXaWR0aAAyNTZ6MhREAAAAGXRFWHRUaHVtYjo6TWltZXR5cGUAaW1hZ2UvcG5nP7JWTgAAABd0RVh0VGh1bWI6Ok1UaW1lADE1NDY5NzYzNzVRMXZzAAAAEnRFWHRUaHVtYjo6U2l6ZQAyODA0M0JW4xBJAAAAWnRFWHRUaHVtYjo6VVJJAGZpbGU6Ly8vZGF0YS93d3dyb290L3d3dy5lYXN5aWNvbi5uZXQvY2RuLWltZy5lYXN5aWNvbi5jbi9maWxlcy8xMTgvMTE4MDExNS5wbmc7DAHHAAAAAElFTkSuQmCC"
		}
		if p.Description.Text != "" {
			p.Description.Des = p.Description.Text
		} else {
			p.Description.Des = p.Description.Translate
		}
		retc <- p
	}(ctx)
	select {
	case ret := <-retc:
		return ret, nil
	case err := <-errc:
		return nil, err
	case <-ctx.Done():
		return nil, errors.New("time exceeded")
	}
}

func makePacket(pl *bytes.Buffer) *bytes.Buffer {
	var buf bytes.Buffer
	// get payload length
	buf.Write(encodeVarint(uint64(len(pl.Bytes()))))
	// write payload
	buf.Write(pl.Bytes())
	return &buf
}

func sendHandshake(conn net.Conn, host string) error {
	pl := &bytes.Buffer{}

	// packet id
	pl.WriteByte(0x00)

	// protocol version
	pl.WriteByte(protocolVersion)

	// server address
	host, port, err := net.SplitHostPort(host)
	if err != nil {
		panic(err)
	}

	pl.Write(encodeVarint(uint64(len(host))))
	pl.WriteString(host)

	// server port
	iPort, err := strconv.Atoi(port)
	if err != nil {
		panic(err)
	}
	_ = binary.Write(pl, binary.BigEndian, int16(iPort))
	// next state (status)
	pl.WriteByte(0x01)
	if _, err := makePacket(pl).WriteTo(conn); err != nil {
		return errors.New("cannot write handshake")
	}

	return nil
}

func sendStatusRequest(conn net.Conn) error {
	pl := &bytes.Buffer{}

	// send request zero
	pl.WriteByte(0x00)

	if _, err := makePacket(pl).WriteTo(conn); err != nil {
		return errors.New("cannot write send status request")
	}

	return nil
}

func encodeVarint(x uint64) []byte {
	var buf [10]byte
	var n int
	for n = 0; x > 127; n++ {
		buf[n] = 0x80 | uint8(x&0x7F)
		x >>= 7
	}
	buf[n] = uint8(x)
	n++
	return buf[0:n]
}

func readPong(rd io.Reader) (*Pong, error) {
	r := bufio.NewReader(rd)
	nl, err := binary.ReadUvarint(r)
	if err != nil {
		return nil, err
	}

	pl := make([]byte, nl)
	_, err = io.ReadFull(r, pl)
	if err != nil {
		return nil, err
	}

	// packet id
	_, n := binary.Uvarint(pl)
	if n <= 0 {
		return nil, errors.New("could not read packet id")
	}

	// string varint
	_, n2 := binary.Uvarint(pl[n:])
	if n2 <= 0 {
		return nil, errors.New("could not read string varint")
	}
	// glg.Debug(string(pl[n+n2:]))
	var pong Pong
	err = json.Unmarshal(pl[n+n2:], &pong)
	if err != nil {
		dec := make(map[string]interface{})
		_ = json.Unmarshal(pl[n+n2:], &dec)
		pong.Description.Translate, _ = dec["description"].(string)
	}
	return &pong, nil
}
