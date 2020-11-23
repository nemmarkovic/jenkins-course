
:: Don't be fooled - this is not a makefile !!!
:: It's not compiling anything

@echo off

if exist "printer.c" (
    if exist "printer.h" (
        echo "Compiling printer.c file..."
    ) else (
		echo "Missing printer.h file"
		goto :bad
	)
) else (
	echo "Missing printer.c file"
	goto :bad
)
sleep 1
echo "Done"
sleep 1


if exist "hello_world.c" (
    if exist "hello_world.h" (
        echo "Compiling hello_world.c file..."
    ) else (
		echo "Missing hello_world.h file"
		goto :bad
	)
) else (
	echo "Missing hello_world.c file"
	goto :bad
)
sleep 1
echo "Done"
sleep 1


echo "Linking final executable hello_world.exe..."
echo.>"hello_world.exe"
sleep 1
echo "Done"
sleep 1

:good
exit 0

:bad
exit 2

