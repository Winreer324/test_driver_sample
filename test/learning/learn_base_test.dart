// https://pub.dev/packages/test#tagging-tests // run by tag test dart test test/widget_test.dart --tags -x test
@Tags(['alpha', 'test'])
import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('base testing', () {
    //  https://pub.dev/packages/test#asynchronous-tests
    test('Future.value() returns the value', () async {
      var value = await Future.value(10);
      expect(value, equals(10));
    }, tags: 'test');

    //  https://pub.dev/packages/test#future-matchers
    test('Future.value() returns the value', () {
      expect(Future.value(10), completion(equals(10)));
    }, tags: 'test');

    test('Future.error() throws the error', () {
      expect(Future.error('oh no'), throwsA(equals('oh no')));
      expect(Future.error(StateError('bad state')), throwsStateError);
    }, tags: 'test');

    test('Stream.fromIterable() emits the values in the iterable', () {
      const length = 10;
      Stream stream = Stream.fromIterable(List.generate(length, (index) => index));

      stream.listen(expectAsync1((number) {
        expect(number, inInclusiveRange(0, length));
      }, count: length));
    }, tags: 'test');

    //  https://pub.dev/packages/test#stream-matchers
    test('process emits status messages', () {
      // Dummy data to mimic something that might be emitted by a process.
      Stream stdoutLines = Stream.fromIterable([
        'Ready.',
        'Loading took 150ms.',
        'Succeeded!',
        'End',
        'End one more',
      ]);

      expect(
          stdoutLines,
          emitsInOrder([
            // Values match individual events.
            'Ready.',

            // Matchers also run against individual events.
            startsWith('Loading took'),

            // Stream matchers can be nested. This asserts that one of two events are
            // emitted after the "Loading took" line.
            // 'Succeeded!',

            emitsAnyOf(['Succeeded!', 'Failed!']),

            emitsAnyOf(['End', 'Failed']),

            endsWith('End one more'),

            // By default, more events are allowed after the matcher finishes
            // matching. This asserts instead that the stream emits a done event and
            // nothing else.
            emitsDone
          ]));
    }, tags: 'test');

    test('process emits a WebSocket URL', () async {
      // Wrap the Stream in a StreamQueue so that we can request events.
      var stdout =
          StreamQueue(Stream.fromIterable(['WebSocket URL:', 'ws://localhost:1234/', 'Waiting for connection...']));

      // Ignore lines from the process until it's about to emit the URL.
      await expectLater(stdout, emitsThrough('WebSocket URL:'));

      // Parse the next line as a URL.
      Uri url = Uri.parse(await stdout.next);
      expect(url.host, equals('localhost'));

      // You can match against the same StreamQueue multiple times.
      await expectLater(stdout, emits('Waiting for connection...'));
    }, tags: 'test');

    /// The following built-in stream matchers are available:
    //
    // emits() matches a single data event.
    // emitsError() matches a single error event.
    // emitsDone matches a single done event.
    // mayEmit() consumes events if they match an inner matcher, without requiring them to match.
    // mayEmitMultiple() works like mayEmit(), but it matches events against the matcher as many times as possible.
    // emitsAnyOf() consumes events matching one (or more) of several possible matchers.
    // emitsInOrder() consumes events matching multiple matchers in a row.
    // emitsInAnyOrder() works like emitsInOrder(), but it allows the matchers to match in any order.
    // neverEmits() matches a stream that finishes without matching an inner matcher.
    // You can also define your own custom stream matchers with StreamMatcher().

    //  https://pub.dev/packages/test#configuring-tests
    test('error-checking test', () {
      // ...
    }, skip: 'TODO: add error-checking.');

    //  https://pub.dev/packages/test#timeouts
    test('even slower test', () async {
      expect(Future.delayed(const Duration(seconds: 13), () => 10), completion(equals(10)));
    }, timeout: const Timeout(Duration(minutes: 2)), tags: 'test');
  });
}
