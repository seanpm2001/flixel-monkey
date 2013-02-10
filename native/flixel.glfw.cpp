
#include <time.h>
#include <math.h>
#include <Shellapi.h>

class flixel {

public:

	static int systemMillisecs() {
		double n;
		time_t t;
		struct tm * timeinfo;		
		time(&t);
		timeinfo = localtime(&t);
		int seconds = (timeinfo->tm_sec + timeinfo->tm_min * 60 + timeinfo->tm_hour * 3600);
		return  (seconds + modf(glfwGetTime(), &n)) * 1000;
	}
	
	static bool isMobile() {
		return false;
	}
	
};
