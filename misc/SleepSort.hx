//
//	SleepSort.hx
//
//	> haxe --interp --main SleepSort.hx
//
//	using as a reference:
//	https://docs.emilua.org/api/0.10/tutorial/getting-started.html#hello-sleepsort
//	and its license is:
//	https://gitlab.com/emilua/emilua#user-content-license
//
//	referece docs:
//	https://haxe.org/manual/std-threading.html
//	https://api.haxe.org/sys/thread/index.html
//

using Sys;

import sys.thread.Thread;
import sys.thread.Deque;

function main() {
	#if (target.threaded)

	final a = [8, 42, 38, 111, 2, 39, 1];

	sort(a, 100);
	"-".println();
	sort(a, 1000);
	"-".println();
	sort(a, 10000);

	"---".println();

	sortZZZ(a, 100, 2);
	"-".println();
	sortZZZ(a, 100, 0.5);
	"-".println();
	sortZZZ(a, 100, 0.25);

	#end
}

#if (target.threaded)
private function sort(a:Array<Int>, d:Int) {
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
