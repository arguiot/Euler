# Use an official Swift 5.8 runtime as a parent image
FROM swift:5.8

# Install LAPACK, LAPACKE, and OpenBLAS (which includes CBLAS)
RUN apt-get update && \
    apt-get install -y liblapack-dev liblapacke-dev libopenblas-dev && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Run the tests with the include paths for LAPACKE and CBLAS
CMD ["swift", "test", "-Xcc", "-I/usr/include", "-Xlinker", "-L/usr/lib"]
