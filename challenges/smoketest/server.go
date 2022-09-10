package smoketest

import (
	"bufio"
	"log"
	"net"
)

// Amount of bytes we read
const BUFFER_SIZE = 2048

func Start(addr string) error {
	listener, err := net.Listen("tcp", addr)
	if err != nil {
		return err
	}
	defer listener.Close()

	log.Printf("Starting server on %s ...", addr)
	for {
		conn, err := listener.Accept()
		if err != nil {
			return err
		}
		log.Printf("Opened new connection for: %s", conn.RemoteAddr())

		go handleClient(conn)
	}
}

func handleClient(conn net.Conn) {
	reader := bufio.NewReader(conn)
	buffer := make([]byte, BUFFER_SIZE)
	total := 0
	for {
		n, err := reader.Read(buffer)
		if err != nil {
			conn.Close()
			log.Printf("Closed connection for %s, received %d bytes in total", conn.RemoteAddr(), total)
			return
		}
		total += n
		conn.Write(buffer[:n])
	}
}
