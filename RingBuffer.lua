local RingBuffer={}
RingBuffer.__index = RingBuffer


function RingBuffer.new(len_a)
	local self=setmetatable({},RingBuffer)
	self.size=len_a
	self.head=1
	self.tail=1
	self.buffer={}
	for i=1,self.size do
		self.buffer[i]='0'
		--print(self.buffer[i])
	end

	self.state='A'
	self.sentence_flag=false
	return self
end


function RingBuffer.Clear(self)
	self.state='A'
	self.sentence_flag=false
	self.head=1
	self.tail=1
end

function RingBuffer.Push(self,character)
	self.buffer[self.head]=character
	self.head=(self.head+1)%(self.size+1)
	if(self.head==0) then
		self.head=1
	end

end

function RingBuffer.Pop(self)
	local temp_a
	temp_a=self.buffer[self.tail]
	self.tail=(self.tail+1)%(self.size+1)
	if(self.tail==0) then
		self.tail=1
	end
	return temp_a
end
function RingBuffer.PrintStats(self)
	print("Size: " .. self.size .. " Head: " .. self.head .. " Tail: " .. self.tail)
end
function RingBuffer.PrintStats_Classic(self)
	print("Size: " .. self.size .. " Head: " .. (self.head-1).. " Tail: " .. (self.tail-1))
end
function  RingBuffer.Push_String(self,string_temp)
	local slen=string_temp:len()
	print(slen)
	for j=1,slen do
		self:Push(string_temp:sub(j,j))
	end
end
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
function TransferString(source,destination)
	local temp
	while (source.tail ~=source.head) do
		temp=source:Pop()
		destination:Push(temp)
	end

end

return RingBuffer
