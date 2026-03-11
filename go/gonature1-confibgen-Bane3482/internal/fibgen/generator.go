package fibonacci

import (
	"errors"
	"runtime"
	"sync/atomic"
)

var ErrOverflowFib = errors.New("overflow fibonacci number")
var ErrUnlock = errors.New("unlock not locked structure")

type Generator interface {
	Next() uint64
}

var _ Generator = (*generatorImpl)(nil)

type generatorImpl struct {
	prev uint64
	this uint64
	lock atomic.Bool
}

func NewGenerator() *generatorImpl {
	return &generatorImpl{
		prev: 1,
		this: 0,
		lock: atomic.Bool{},
	}
}

func (g *generatorImpl) GeneratorLock() {
	for !g.lock.CompareAndSwap(false, true) {
		runtime.Gosched()
	}
}

func (g *generatorImpl) GeneratorUnlock() {
	if !g.lock.Load() {
		panic(ErrUnlock)
	}
	g.lock.Store(false)
}

func (g *generatorImpl) Next() uint64 {
	g.GeneratorLock()

	defer g.GeneratorUnlock()

	if g.prev > ^g.this {
		if g.prev == g.this {
			panic(ErrOverflowFib)
		}
		g.prev = 0
	}

	g.prev, g.this = g.this, g.prev

	g.this += g.prev

	return g.prev
}
