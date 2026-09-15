// Package dto holds the request and response bodies of the REST API.
//
// Having them in one place keeps the wire contract readable: the Flutter client
// mirrors exactly these types, and a field rename here is a compile error on
// both sides. Handlers translate a DTO into plain service arguments, so no DTO
// type ever reaches `internal/service` or `internal/store`.
package dto

// IDResponse is the payload of a create that only needs to hand back a new id.
type IDResponse struct {
	ID string `json:"id"`
}

// CountResponse reports how many documents an administrative action affected.
type CountResponse struct {
	Count int64 `json:"count"`
}

// MessageResponse is a bare human readable confirmation.
type MessageResponse struct {
	Message string `json:"message"`
}
