require "spec"
require "webmock"
require "../src/slack"

Spec.before_each &->WebMock.reset
