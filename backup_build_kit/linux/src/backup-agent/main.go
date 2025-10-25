package main

import (
	"log"
	"net/http"
	"os"
	"time"
)

func main() {
	logDir := "/var/log/backup-agent"
	os.MkdirAll(logDir, 0755)
	f, _ := os.OpenFile(logDir+"/agent.log", os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0644)
	defer f.Close()
	log.SetOutput(f)
	log.Println("backup-agent started")

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(200)
		w.Write([]byte("ok"))
	})

	go func() {
		log.Println("http server on :9876")
		http.ListenAndServe(":9876", nil)
	}()

	for {
		log.Println("heartbeat", time.Now().UTC().Format(time.RFC3339))
		time.Sleep(60 * time.Second)
	}
}
