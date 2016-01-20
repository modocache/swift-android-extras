# Can't I do this all myself? I think I get what this script is trying to do.
# What if this is all run as ./release/deploy.sh?
# Things I need:
# ../bin/swift
# ../bin/swift-demangle
# ../bin/swift-autolink-extract
# ../bin/swiftc
# ../bin/swiftc-android
# ../bin/swift-android-push
# ../bin/armv7-none-linux-androideabi-ld
# ../bin/swift-androidfix
# ../bin/swiftc-pm-android
# ../lib/swift
# ../lib/swift/android/libicuuc.so
# ../swiftpm-linux-x86_64/lib/swift
# ../swiftpm-linux-x86_64/debug/swift-build
# ../llbuild-linux-x86_64/bin
# ../llvm-linux-x86_64/lib/clang/3.8.0

SWIFT_BUILD_DIR=~/GitHub/apple/build/Ninja-ReleaseAssert/swift-linux-x86_64

rm -r swiftandroid            # rm -r $CURRENT/swiftandroid
mkdir swiftandroid            # mkdir $CURRENT/swiftandroid
cd swiftandroid               # cd $CURRENT/swiftandroid
cp ~/swift/README.android ./  # NOTE: Copies a README zhuowei must have on his local machine
mkdir bin                     # mkdir $CURRENT/swiftandroid/bin
IFS=" "                       # NOTE: I think this can be deleted.

# Seems like the assumption is that all of the cool Swift binaries--swiftc,
# swift-autolink-extract, etc--are in release/bin already.
for i in swift swift-demangle
do
	echo $i                   # strip -o $CURRENT/swiftandroid/bin/swift $CURRENT/../bin/swift
	strip -o bin/$i $SWIFT_BUILD_DIR/bin/$i # strip -o $CURRENT/swiftandroid/bin/swift-demangle $CURRENT/../bin/swift-demangle
done

for i in swift-autolink-extract swiftc swiftc-android swift-android-push armv7-none-linux-androideabi-ld swift-androidfix swiftc-pm-android
do                            # NOTE: `cp -P` means "never follow symlinks in source". 
	cp -P $SWIFT_BUILD_DIR/bin/$i bin/$i    # cp -P $CURRENT/../bin/$i $CURRENT/swiftandroid/bin/$i
done

# Another assumption here: that release/lib contains a path
# release/lib/swift/android/libucucc.so.
mkdir lib                     # mkdir $CURRENT/swiftandroid/lib
cp -r $SWIFT_BUILD_DIR/lib/swift lib/       # cp -r $CURRENT/../lib/swift $CURRENT/swiftandroid/lib/
[ -a lib/swift/android/libicuuc.so ] || echo "WHERE IS ICU"
# cp -r ../../swiftpm-linux-x86_64/lib/swift lib/          # cp -r  $CURRENT/../swiftpm-linux-x86_64/lib/swift release/swiftandroid/lib/
# cp -r ../../swiftpm-linux-x86_64/debug/swift-build bin/  # cp -r  $CURRENT/../swiftpm-linux-x86_64/debug/swift-build release/swiftandroid/bin/
# cp -r ../../llbuild-linux-x86_64/bin/* bin/              # cp -r  $CURRENT/../llbuild-linux-x86_64/bin/* release/swiftandroid/bin/
# rm lib/swift/clang                                       # rm swift-android-extras/release/swiftandroid/lib/swift/clang
# cp -r ../../llvm-linux-x86_64/lib/clang/3.8.0 lib/swift/clang # cp -r 
cd ..                                                    # cd swift-android-extras/release
rm swift_android.tar.xz                                  # rm swift-android-extras/release/swift_android.tar.xz
tar cJf swift_android.tar.xz swiftandroid                # tar cJF swift-android-extras/release/swift_android.tar.xz swiftandroid
