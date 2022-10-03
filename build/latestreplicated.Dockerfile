FROM docker.io/library/golang:1.19 AS build

WORKDIR /go/src/app

COPY go.mod ./
COPY go.sum ./
RUN go mod download -x

COPY . .
RUN CGO_ENABLED=0 go build ./cmd/latestreplicated

FROM gcr.io/distroless/static-debian11
WORKDIR /
USER nonroot:nonroot
COPY --from=build /go/src/app/latestreplicated /
ENTRYPOINT ["/latestreplicated"]
