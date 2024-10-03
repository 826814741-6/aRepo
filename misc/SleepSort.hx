//
//	SleepSort.hx
//
//	> haxe --interp --main SleepSort
//
//	using as a reference:
//	https://docs.emilua.org/api/0.10/tutorial/getting-started.html#hello-sleepsort
//	and its license is:
//	https://gitlab.com/emilua/emilua#user-content-license
//
//	reference docs:
//	https://haxe.org/manual/std-threading.html
//	https://api.haxe.org/sys/thread/index.html
//

using Sys;

import sys.thread.Deque;
import sys.thread.Thread;

function main() {
	#if (target.threaded)

	final a = [8, 42, 38, 111, 2, 39, 1];

	"--- by add(): 'Adds an element at the end of this Deque.'".println();

	sortByAdd(a, 100);
	"-".println();
	sortByAdd(a, 1000);
	"-".println();
	sortByAdd(a, 10000);

	"--- by push(): 'Adds an element at the front of this Deque.'".println();

	sortByPush(a, 100);
	"-".println();
	sortByPush(a, 1000);
	"-".println();
	sortByPush(a, 10000);

	"--- and s...or..t........Z..Z.....ZZZZZZZZZZZZZ".println();

	sortZZZ(a, 100, 2);
	"-".println();
	sortZZZ(a, 100, 0.5);
	"-".println();
	sortZZZ(a, 100, 0.25);

	#end
}

#if (target.threaded)
private function sortByAdd(a:Array<Int>, d:Int) {
	final dq = new Deque();

	for (n in a) {
		Thread.create(() -> {
			(n / d).sleep();
			dq.add(n);
		});
	}

	for (_ in a) {
		dq.pop(true).println();
	}
}

private function sortByPush(a:Array<Int>, d:Int) {
	final dq = new Deque();

	for (n in a) {
		Thread.create(() -> {
			(n / d).sleep();
			dq.push(n);
		});
	}

	for (_ in a) {
		dq.pop(true).println();
	}
}

private function sortZZZ(a:Array<Int>, d:Int, wait:Float) {
	for (n in a) {
		Thread.create(() -> {
			(n / d).sleep();
			n.println();
		});
	}
	wait.sleep();
}
#end
