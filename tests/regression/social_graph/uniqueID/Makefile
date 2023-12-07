TARGET := UniqueID

$(TARGET): UniqueID.cpp
	g++ -std=c++11 -o $@ $^

run: $(TARGET)
	./$(TARGET)

clean: 
	rm -f $(TARGET) *.o