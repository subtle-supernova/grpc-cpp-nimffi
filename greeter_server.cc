
#include <iostream>
#include <memory>
#include <string>

#include "helloworld.grpc.pb.h"
#include "fib.h"

#include <grpc++/grpc++.h>

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
using helloworld::HelloRequest;
using helloworld::HelloReply;
using helloworld::Greeter;

class GreeterServiceImpl final : public Greeter::Service {
  Status SayHello(ServerContext* context, const HelloRequest* request,
      HelloReply* reply) override {

    std::string prefix("Hello ");
    reply->set_message(prefix + request->name());
    return Status::OK;
  }
};


void RunServer() {
  std::string server_address("0.0.0.0:50051");
  GreeterServiceImpl service;

  ServerBuilder builder;

  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  builder.RegisterService(&service);

  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;

  server->Wait();
}

/*
struct Person {
  string name;
  int age;
};
*/

int main(int argc, char** argv) {
  NimMain();
  for (int f = 0; f < 10; f++)
    printf("Fib of %d is %d\n", f, fib(f));

  somethingPerson* me; 
  mkperson(me);
  //printf("Person is %s\n", me->name);

  RunServer();

  return 0;
}


