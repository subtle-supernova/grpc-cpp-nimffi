
CXX = clang++
CC = clang
CPPFLAGS += `pkg-config --cflags protobuf grpc`
CFLAGS = -Inimcache -I/usr/local/nim/lib
CXXFLAGS += -Inimcache -I/usr/local/nim/lib -std=c++11

LDFLAGS += -L/usr/local/lib `pkg-config --libs protobuf grpc++ grpc`\
					 -Lnimcache\
					 -v -lgrpc++_reflection\
					 -ldl

GRPC_CPP_PLUGIN = grpc_cpp_plugin
GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`

PROTOC = protoc
PROTOS_PATH = ./protos

vpath %.proto $(PROTOS_PATH)

all: greeter_server greeter_client

greeter_server: helloworld.pb.o helloworld.grpc.pb.o greeter_server.o nimcache/*.o 
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

greeter_client: helloworld.pb.o helloworld.grpc.pb.o greeter_client.o
	$(CXX) $^ $(LDFLAGS) -o $@ 

nimcache: nimcache/*.c
	$(CC) $(CFLAGS) -c $^ $(LDFLAGS)

nim:
	nim cpp --noMain --noLinking --header:fib.h fib.nim

.PRECIOUS: %.grpc.pb.cc
%.grpc.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<

.PRECIOUS: %.pb.cc
%.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<

clean:
	rm -f *.o *.pb.cc *.pb.h greeter_server greeter_client
	rm -rf nimcache
