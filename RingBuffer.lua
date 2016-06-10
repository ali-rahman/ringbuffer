local RingBuffer={}
RingBuffer.__index = RingBuffer

--Creates a ring buffer of size "len_a". A state variable is also included for use in FSM implementations of transfer of formatted content(e.g. NMEA) between ring buffers.end
--The boolean flag variable can be used to indicate to another process of certain events e.g. a terminating character has been received.
function RingBuffer.new(len_a)
	local self=setmetatable({},RingBuffer)
	self.size=len_a
	self.head=1
	self.tail=1
	self.buffer={}
	for i=1,self.size do
		self.buffer[i]='0'
	end
	self.state='A'
	self.sentence_flag=false
	return self
end

--Clear ring buffer. Head and tail revert to base index. State and Flag are reset.
function RingBuffer.Clear(self)
	self.state='A'
	self.sentence_flag=false
	self.head=1
	self.tail=1
end
--Push character into ring buffer
function RingBuffer.Push(self,character)
	self.buffer[self.head]=character
	self.head=(self.head+1)%(self.size+1)
	if(self.head==0) then
		self.head=1
	end
end
--Pop character from ring buffer
function RingBuffer.Pop(self)
	local temp_a
	temp_a=self.buffer[self.tail]
	self.tail=(self.tail+1)%(self.size+1)
	if(self.tail==0) then
		self.tail=1
	end
	return temp_a
end
--Print size and positions of the head and tail pointers
function RingBuffer.PrintStats(self)
	print("Size: " .. self.size .. " Head: " .. self.head .. " Tail: " .. self.tail)
end
--Prints parameters while keeping 0 as the base index
function RingBuffer.PrintStats_Classic(self)
	print("Size: " .. self.size .. " Head: " .. (self.head-1).. " Tail: " .. (self.tail-1))
end
--Push the contents of the passed string into the ring buffer
function  RingBuffer.Push_String(self,string_temp)
	local slen=string_temp:len()
	print(slen)
	for j=1,slen do
		self:Push(string_temp:sub(j,j))
	end
end
--Print the contents of a ring buffer
function RingBuffer.PrintString(self)
	local t_i=self.head
	local t_j=self.tail
	local printed_string=""
	local print_char
	while(self.tail~=self.head) do
		print_char=self:Pop()
		printed_string=printed_string .. print_char
	end
	self.head=t_i
	self.tail=t_j
	print(printed_string)
end
--Pop contents from one ring buffer and push it to another
function TransferString(source,destination)
	local temp
	while (source.tail ~=source.head) do
		temp=source:Pop()
		destination:Push(temp)
	end
end

return RingBuffer
