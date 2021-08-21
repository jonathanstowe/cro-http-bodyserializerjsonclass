# Cro::HTTP::BodySerializerJSONClass

A Cro::HTTP::BodySerializer that knows about JSON::Class objects

![Build Status](https://github.com/jonathanstowe/cro-http-bodyserializerjsonclass/workflows/CI/badge.svg)


## Synopsis

```raku
use Cro::HTTP::Router;
use Cro::HTTP::Server;
use JSON::Class;
use Cro::HTTP::BodySerializerJSONClass;

class Foo does JSON::Class {
   has DateTime $.date is marshalled-by('Str') = DateTime.now;
}

my $app = route {
    get -> {
        content 'application/json', Foo.new;
    }
};

my Cro::Service $service = Cro::HTTP::Server.new(
   host                 => 'localhost', 
   port                 => 7798,
   application          => $app, 
   add-body-serializers => [ Cro::HTTP::BodySerializerJSONClass]
);

$service.start;

react whenever signal(SIGINT) { $service.stop; exit; }

```

## Description

This provides a body serializer for `Cro::HTTP` that allows you to pass an object that does `JSON::Class` as an `application/json`
response body.  It simply needs to be added to the body serializers with the `add-body-serializers` parameter to the constructor
of the `Cro::HTTP::Server`.  Similarly it can be used to serialize a request body  of a `Cro::HTTP::Client` if the `add-body-serializers`
is provided to the constructor of `Cro::HTTP::Client`.

It might simplify programme design by using, for example, existing objects as the response to a web request.

## Installation

Assuming you have a working Rakudo installation you should be able to install this with *zef* :


    zef install Cro::HTTP::BodySerializerJSONClass


## Support

Please feel free to post suggestions/patches/etc at [Github](https://github.com/jonathanstowe/cro-http-bodyserializerjsonclass/issues).


## Licence & Copyright

This library is free software.  Please see the [LICENCE](LICENCE) file in the distribution.

© Jonathan Stowe 2021
