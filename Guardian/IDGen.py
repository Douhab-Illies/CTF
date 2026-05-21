
filename = f"gen.txt"
with open(filename, "w") as f:
	for number in range(1000000):
		f.write(f"GU{number:07d}\n")
