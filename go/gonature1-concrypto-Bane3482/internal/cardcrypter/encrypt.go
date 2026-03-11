package cardcrypter

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"runtime"
	"sync"
	"unsafe"
)

var ErrNegativeWorkers = errors.New("negative workers")

const cardsCount = 16

type CardNumber [cardsCount]byte

type Card struct {
	ID     string
	Number CardNumber
}

type Crypter interface {
	Encrypt(cards []Card, key []byte) ([]string, error)
}

type crypterImpl struct {
	workers int
}

func New(opts ...CrypterOption) *crypterImpl {
	c := &crypterImpl{workers: runtime.GOMAXPROCS(0)}

	for _, opt := range opts {
		opt(c)
	}

	return c
}

type CrypterOption func(*crypterImpl)

func WithWorkers(workers int) CrypterOption {
	return func(s *crypterImpl) {
		s.workers = workers
	}
}

func (c *crypterImpl) Encrypt(cards []Card, key []byte) ([]string, error) {
	if len(cards) == 0 {
		return []string{}, nil
	}

	if c.workers <= 0 {
		return nil, ErrNegativeWorkers
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}
	nonceSize := gcm.NonceSize()

	wg := new(sync.WaitGroup)

	workers := min(c.workers, len(cards))

	blockSize := len(cards) / workers
	if len(cards)%workers != 0 {
		blockSize++
	}

	out := make([]string, len(cards))
	n := len(cards)
	for w := 0; w < workers; w++ {
		left := w * blockSize
		right := min(n, w*blockSize+blockSize)
		nonce := make([]byte, gcm.NonceSize())
		buf := make([]byte, nonceSize, nonceSize+cardsCount+gcm.Overhead())
		wg.Go(func() {
			for i := left; i < right; i++ {
				_, err := rand.Read(nonce)
				if err != nil {
					panic("unreachable")
				}

				copy(buf, nonce)

				result := gcm.Seal(
					buf,
					nonce,
					cards[i].Number[:],
					unsafe.Slice(unsafe.StringData(cards[i].ID), len(cards[i].ID)),
				)

				newBuf := make([]byte, hex.EncodedLen(len(result)))
				hex.Encode(newBuf, result)
				out[i] = unsafe.String(unsafe.SliceData(newBuf), len(newBuf))
			}
		})
	}
	wg.Wait()

	return out, nil
}
