import std.socket;
import std.stdio;
import std.conv;
import std.format;
import std.algorithm;
import std.string;
import std.array;
import core.exception;

string getUrlData(string url, ushort port, int receive_size = 1024, string header = null)
{
	Socket s = new TcpSocket();
	Address addr = getAddress(url, port)[0];
	
	s.connect(addr);

	char[] buffer;
	buffer.length = receive_size;

	s.send(header ? header : format!"GET / HTTP/1.1\r\nHost: %s\r\n\r\n"(url));
	s.receive(buffer);
	s.close();

	return to!string(buffer);
}

void main()
{
	while (1)
	{
		write("Enter website, port and receive segment size: ");
		auto line = readln.chomp;
		
		if (line == "exit")
		{
			writeln("Thanks for reading/using my trash little program :)");
			return;
		}
		
		auto res = splitter(line, ' ').array;

		writeln(res);

		try {
			writeln(getUrlData(res[0], to!ushort(res[1]), to!int(res[2])));
		} catch (RangeError)
		{ writeln("Enter the correct amount of parameters please.");
		} catch (ConvException)
		{ writeln("Please enter correct datatypes."); 
		} catch (SocketOSException)
		{ writeln("Enter a valid hostname/port."); }
	}
}
