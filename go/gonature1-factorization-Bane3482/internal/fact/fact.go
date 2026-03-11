package fact

import (
	"context"
	"errors"
	"fmt"
	"io"
	"strings"
	"sync"
)

var (
	ErrFactorizationCancelled = errors.New("error factorization cancelled")
	ErrWriterInteraction      = errors.New("error writer interaction")
)

type Factorizer interface {
	Factorize(ctx context.Context, numbers []int, writer io.Writer) error
}

type factorizerImpl struct {
	factWorkers  int
	writeWorkers int
}

func New(opts ...FactorizeOption) (*factorizerImpl, error) {
	f := &factorizerImpl{
		factWorkers:  1,
		writeWorkers: 1,
	}
	for _, opt := range opts {
		opt(f)
	}
	if f.factWorkers <= 0 || f.writeWorkers <= 0 {
		return nil, fmt.Errorf("invalid workers number: factorization(%d) or write(%d)", f.factWorkers, f.writeWorkers)
	}
	return f, nil
}

type FactorizeOption func(*factorizerImpl)

func WithFactorizationWorkers(workers int) FactorizeOption {
	return func(f *factorizerImpl) {
		f.factWorkers = workers
	}
}

func WithWriteWorkers(workers int) FactorizeOption {
	return func(f *factorizerImpl) {
		f.writeWorkers = workers
	}
}

type F[T, R any] = func(T) R

func workerPool[T, R any](
	ctx context.Context,
	cancel context.CancelCauseFunc,
	input <-chan T,
	f F[T, R],
	n int,
	needOut bool,
) (<-chan R, *sync.WaitGroup) {
	var output chan R
	if needOut {
		output = make(chan R)
	}
	wg := new(sync.WaitGroup)
	for range n {
		wg.Go(func() {
			for {
				select {
				case <-ctx.Done():
					cancel(ErrFactorizationCancelled)
					return
				case v, ok := <-input:
					if !ok {
						return
					}

					select {
					case <-ctx.Done():
						cancel(ErrFactorizationCancelled)
						return
					default:
						result := f(v)
						if needOut {
							select {
							case <-ctx.Done():
								cancel(ErrFactorizationCancelled)
								return
							case output <- result:
							}
						}
					}
				}
			}
		})
	}
	if needOut {
		go func() {
			wg.Wait()
			close(output)
		}()
	}
	return output, wg
}

func factorization(number int) string {
	var result strings.Builder
	fmt.Fprintf(&result, "%d = ", number)
	var key bool
	if number < 0 {
		fmt.Fprintf(&result, "-1")
		if number%2 == 0 {
			number /= 2
			fmt.Fprintf(&result, " * 2")
		}
		number *= -1
		key = true
	}
	if number <= 1 && !key {
		fmt.Fprintf(&result, "%d\n", number)
		return result.String()
	}
	for i := 2; i <= number/i; i++ {
		if number%i == 0 {
			if key {
				fmt.Fprintf(&result, " * ")
			}
			fmt.Fprintf(&result, "%d", i)
			number /= i
			i--
			key = true
		}
	}
	if number != 1 {
		if key {
			fmt.Fprintf(&result, " * ")
		}
		fmt.Fprintf(&result, "%d", number)
	}
	fmt.Fprintf(&result, "\n")
	return result.String()
}

func writeAnswer(cancel context.CancelCauseFunc, writer io.Writer) func(string) error {
	return func(answer string) error {
		if _, err := io.WriteString(writer, answer); err != nil {
			cancel(errors.Join(err, ErrWriterInteraction))
			return err
		}
		return nil
	}
}

func combineContexts(ctxMain, ctxStop context.Context) (context.Context, context.CancelCauseFunc) {
	ctx, cancel := context.WithCancelCause(context.Background())
	go func() {
		select {
		case <-ctxMain.Done():
			cancel(errors.Join(context.Cause(ctxMain), ErrFactorizationCancelled))
			return
		case <-ctx.Done():
			return
		case <-ctxStop.Done():
			return
		}
	}()
	return ctx, cancel
}

func readDataCh(ctx context.Context, numbers []int) (<-chan int, *sync.WaitGroup) {
	in := make(chan int)
	wg := new(sync.WaitGroup)
	wg.Go(func() {
		defer close(in)
		for i := 0; i < len(numbers); i++ {
			select {
			case <-ctx.Done():
				return
			case in <- numbers[i]:
			}
		}
	})
	return in, wg
}

func (f *factorizerImpl) Factorize(
	ctxMain context.Context,
	numbers []int,
	writer io.Writer,
) error {
	ctxStop, stop := context.WithCancel(context.Background())
	ctx, cancel := combineContexts(ctxMain, ctxStop)

	in, wgIO := readDataCh(ctx, numbers)
	factResult, wgFact := workerPool(ctx, cancel, in, factorization, f.factWorkers, true)
	_, wgWrite := workerPool(ctx, cancel, factResult, writeAnswer(cancel, writer), f.writeWorkers, false)

	wgFact.Wait()
	wgWrite.Wait()
	wgIO.Wait()

	stop()

	return context.Cause(ctx)
}
