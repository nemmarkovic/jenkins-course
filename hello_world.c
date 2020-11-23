
#include "hello_world.h"
#include "printer.h"

void main_body() {
	print_message("-----------------------------------------------\n");
	print_message("Hello cruel world :(\n");
	print_message("-----------------------------------------------\n");
}

int main()
{
	print_message("Executing application...\n");
	main_body();
	print_message("Done!\n");
	return 0;
}

