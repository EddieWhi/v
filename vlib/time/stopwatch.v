// Copyright (c) 2019-2023 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module time

[params]
pub struct StopWatchOptions {
	auto_start bool = true
}

// StopWatch is used to measure elapsed time.
pub struct StopWatch {
mut:
	elapsed u64
pub mut:
	start ?u64
	end   ?u64
}

// new_stopwatch initializes a new StopWatch with the current time as start.
pub fn new_stopwatch(opts StopWatchOptions) StopWatch {
	mut initial := u64(0)
	if opts.auto_start {
		initial = sys_mono_now()
	}
	return StopWatch{
		elapsed: 0
		start: initial
		end: none
	}
}

// start starts the stopwatch. If the timer was paused, restarts counting.
pub fn (mut t StopWatch) start() {
	t.start = sys_mono_now()
	t.end = none
}

// restart restarts the stopwatch. If the timer was paused, restarts counting.
pub fn (mut t StopWatch) restart() {
	t.start = sys_mono_now()
	t.end = none
	t.elapsed = 0
}

// stop stops the timer, by setting the end time to the current time.
pub fn (mut t StopWatch) stop() {
	t.end = sys_mono_now()
}

// pause resets the `start` time and adds the current elapsed time to `elapsed`.
pub fn (mut t StopWatch) pause() {
	if start := t.start {
		if end := t.end {
			t.elapsed += end - start
		} else {
			t.elapsed += sys_mono_now() - start
		}
	}
	t.start = none
	t.end = none
}

// elapsed returns the Duration since the last start call
pub fn (t StopWatch) elapsed() Duration {
	if start := t.start {
		if end := t.end {
			return Duration(i64(end - start + t.elapsed))
		} else {
			return Duration(i64(sys_mono_now() - start + t.elapsed))
		}
	}
	return Duration(i64(t.elapsed))
}
