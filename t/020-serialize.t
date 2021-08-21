#!/usr/bin/env raku

use Test;
use Cro::HTTP::Response;
use Cro::HTTP::Request;
use JSON::Class;
use Cro::BodySerializerSelector;
use Cro::HTTP::BodySerializerJSONClass;

class Foo does JSON::Class {
    has Str $.stuff = 'Test Stuff';
}

my $foo1 = Foo.new;

my $request = Cro::HTTP::Request.new(:http-version<1.1>);

my $message = Cro::HTTP::Response.new(status => 200, :$request);

$message.append-header('Content-Type', 'application/json');
$message.set-body($foo1);

$message.body-serializer-selector = Cro::BodySerializerSelector::Prepend.new(
    serializers => [ Cro::HTTP::BodySerializerJSONClass ],
    next => $message.body-serializer-selector
);

my $body-json;

lives-ok { $body-json = await $message.body-text }, "Body text";

my $foo2 = Foo.from-json($body-json);

is $foo2.stuff, $foo1.stuff, "got the correct thing serialized";

done-testing;

# vim: ft=raku
