package ServerStatus

import (
	"bufio"
	"bytes"
	"encoding/binary"
	"encoding/json"
	"errors"
	"github.com/astaxie/beego"
	"io"
	"net"
	"strconv"
)

const (
	protocolVersion = 0x47
)

type Pong struct {
	Version struct {
		Name     string
		Protocol int
	} `json:"version"`
	Players struct {
		Max    int `json:"max"`
		Online int `json:"online"`
		Sample []map[string]string
	} `json:"players"`
	Description struct {
		Text      string `json:"text"`
		Translate string `json:"translate"`
	} `json:"description"`
	FavIcon string `json:"favicon"`
	ModInfo struct {
		ModType string `json:"type"`
		ModList []struct {
			ModID      string `json:"modid"`
			ModVersion string `json:"version"`
		} `json:"modList"`
	} `json:"modinfo"`
}

/*func Test(){
	host := "n3.ntmc.tech:23051"
	pong,_:=Ping(host)
	beego.Info(pong)
}
*/

func Ping(host string) (Pong, error) {
	conn, err := net.Dial("tcp", host)
	if err != nil {
		beego.Error(err)
		return Pong{}, err
	}
	if err := sendHandshake(conn, host); err != nil {
		beego.Error(err)
		return Pong{}, err
	}
	if err := sendStatusRequest(conn); err != nil {
		beego.Error(err)
		return Pong{}, err
	}
	pong, err := readPong(conn)
	//beego.Debug(pong.FavIcon)
	if err != nil {
		beego.Error(err)
		return Pong{}, err
	}
	return *pong, nil
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
		return nil, errors.New("could not read length")
	}

	pl := make([]byte, nl)
	_, err = io.ReadFull(r, pl)
	if err != nil {
		return nil, errors.New("could not read length given by length header")
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
	//beego.Debug(string(pl[n+n2:]))
	var pong Pong
	if err := json.Unmarshal(pl[n+n2:], &pong); err != nil {
		return nil, errors.New("could not read pong json")
	}

	return &pong, nil
}
