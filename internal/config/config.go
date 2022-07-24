package config

import (
	"encoding/json"
	"errors"
	"os"
)

type CgsConfig struct {
	Bind string `json:"bind"`
	Root string `json:"root"`
}

type Config struct {
	Cgs CgsConfig `json:"cgs"`
	Cge string    `json:"cge"`
}

func ParseConfigFile(file string) (*Config, error) {
	f, err := os.Open(file)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	result := Config{}
	dec := json.NewDecoder(f)
	err = dec.Decode(&result)
	if err != nil {
		return nil, err
	}
	return &result, nil
}

func (conf *Config) Valid() error {
	err := conf.Cgs.Valid()
	if err != nil {
		return err
	}
	if len(conf.Cge) < 7 {
		return err
	}
	return nil
}

func (conf *CgsConfig) Valid() error {
	if len(conf.Bind) < 2 {
		return errors.New("invalid bind")
	}
	return nil
}
