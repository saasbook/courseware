# **Module 3 Problems**

Correct answers are **bolded**.

## Architectural patterns

What are some characteristics of the client-server architectural pattern?

**Servers are specialized to serve large numbers of clients simultaneously**

Every host in the network effectively acts as both a client and a server

**Clients are specialized to send requests to and communicate with servers**

The server is typically an individual supercomputer

**It is an example of a design pattern**

## HTTP

Which statements are true regarding the HTTP protocol?

Since HTTP is a request-response protocol, any request that a client makes will always receive a response

Since HTTP is a stateless protocol, there is no way to keep track of information between requests

**Any valid HTTP request must include an HTTP method and uniform resource identifier (URI)**

**Any valid HTTP response must include a three digit status code**

HTTP cookies are initially sent from the client to the server and sent back by the server to identify them to the client for future interactions

## Status Codes

When you try to visit a website, it redirects you to a second website. But that second website never loads, and instead you see “Internal Server Error.” Which status codes were likely returned in response to your HTTP requests by the two websites that you visited?

307, 404

500, 404

**307, 500**

201, 307

## TCP

Which statements are true regarding the Transmission Control Protocol (TCP)?

It enables network communication through exchange of unordered sequences of bytes

**It is built on top of IP**

TCP is encrypted using public-key cryptography and therefore secure against eavesdroppers

**Opening a TCP connection requires specifying an IP address and a port number**

**For a TCP connection to be accepted, some program has to be listening on the requested port**

## Visiting A Random Website

You type the following URL into the browser:

[http://randomwebsite.com/random_stuff/random_function?a=chicken&b=nuggets](http://randomwebsite.com/random_stuff/random_function?a=chicken&b=nuggets)

The site successfully loads and shows you an image of a chicken nugget. During the process of connecting to the website:

**The hostname of[ randomwebsite.com](http://randomwebsite.com) was converted to an IP address by the DNS internet service**

A connection was opened on a random port number from 1 to 65535

**A GET request was sent to the resource at the path /random_stuff/random_function**

**The parameters that were sent with the request were “a” with value “chicken” and “b” with value “nuggets**”

If instead a GET request had been to the resource at the path /random_stuff/random_function without any query terms, then the website would not have displayed an image of a chicken nugget

## REST 

Select the statements that are true regarding RESTful APIs:

**They tend to be resource-oriented rather than action-oriented**

**HTTP requests to the API include information about the action that needs to be performed on a resource**

The GET requests to these APIs typically have side effects while POST, PUT, and PATCH do not

The information from previous requests is often used as implicit information to satisfy future requests

**Many servers providing RESTful APIs specify a base URI which serves as the API endpoint**

## SOA Pros/Cons 

Which statements are true about the pros/cons of using a service-oriented architecture (SOA)?

**SOA tends to be more Agile-friendly**

**Independent subsystems can usually be improved more quickly in response to customer requests**

**Dependability can become more challenging due to the possibility partial failures**

**More development work is often required**

**Developers frequently have to learn how to operate each independent service**

## URI Components

Consider the following URI:

[https://www.ilikewaffles.com:80/waffles/syrup?pancake=sucks&num=5&chocolate=true](https://www.ilikewaffles.com:80/waffles/syrup?pancake=sucks&num=5&chocolate=true)

What is the host name ? 

**www.ilikewaffles.com**

What is the port number ? 

**80**

What is the path? 

**waffles/syrup**

What are the parameters & their values? 

**pancake = sucks**

**num = 5**

**chocolate = true**