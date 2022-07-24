package service

import (
	"context"
	"net"
	"net/http"

	"github.com/golang/glog"

	"regame/cgs/internal/config"
)

type Service struct {
	ctx    context.Context
	cancel context.CancelFunc

	conf *config.Config

	listener   net.Listener
	mux        *http.ServeMux
	httpServer *http.Server
}

func New(conf *config.Config) *Service {
	return &Service{
		conf: conf,
	}
}

func (svc *Service) Run(ctx context.Context) error {
	svc.ctx, svc.cancel = context.WithCancel(ctx)
	defer svc.cancel()

	listener, err := net.Listen("tcp", svc.conf.Cgs.Bind)
	if err != nil {
		glog.Errorln(err)
		return err
	}
	svc.listener = listener

	svc.mux = http.NewServeMux()
	svc.httpServer = &http.Server{Handler: svc.mux}
	svc.registerHandler()

	go func() {
		select {
		case <-svc.ctx.Done():
			_ = svc.httpServer.Close()
			_ = svc.listener.Close()
		}
	}()
	return svc.httpServer.Serve(listener)
}

func (svc *Service) Stop() {
	if svc.cancel != nil {
		svc.cancel()
	}
}

func (svc *Service) registerHandler() {
	svc.mux.HandleFunc("/dosignal", svc.doSignal)

	fs := http.FileServer(http.Dir(svc.conf.Cgs.Root))
	svc.mux.Handle("/", fs)
}

func (svc *Service) doSignal(w http.ResponseWriter, req *http.Request) {
}
