# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gstle android ios gstle-cross evm all test clean
.PHONY: gstle-linux gstle-linux-386 gstle-linux-amd64 gstle-linux-mips64 gstle-linux-mips64le
.PHONY: gstle-linux-arm gstle-linux-arm-5 gstle-linux-arm-6 gstle-linux-arm-7 gstle-linux-arm64
.PHONY: gstle-darwin gstle-darwin-386 gstle-darwin-amd64
.PHONY: gstle-windows gstle-windows-386 gstle-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gstle:
	build/env.sh go run build/ci.go install ./cmd/gstle
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gstle\" to launch gstle."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gstle.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Gstle.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	./build/clean_go_build_cache.sh
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

gstle-cross: gstle-linux gstle-darwin gstle-windows gstle-android gstle-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gstle-*

gstle-linux: gstle-linux-386 gstle-linux-amd64 gstle-linux-arm gstle-linux-mips64 gstle-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-*

gstle-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gstle
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep 386

gstle-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gstle
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep amd64

gstle-linux-arm: gstle-linux-arm-5 gstle-linux-arm-6 gstle-linux-arm-7 gstle-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep arm

gstle-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gstle
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep arm-5

gstle-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gstle
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep arm-6

gstle-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gstle
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep arm-7

gstle-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gstle
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep arm64

gstle-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gstle
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep mips

gstle-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gstle
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep mipsle

gstle-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gstle
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep mips64

gstle-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gstle
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gstle-linux-* | grep mips64le

gstle-darwin: gstle-darwin-386 gstle-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gstle-darwin-*

gstle-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gstle
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-darwin-* | grep 386

gstle-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gstle
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-darwin-* | grep amd64

gstle-windows: gstle-windows-386 gstle-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gstle-windows-*

gstle-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gstle
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-windows-* | grep 386

gstle-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gstle
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gstle-windows-* | grep amd64
