# Perfect-Squishy

<p align="center">
    <a href="http://perfect.org/get-involved.html" target="_blank">
        <img src="http://perfect.org/assets/github/perfect_github_2_0_0.jpg" alt="Get Involved with Perfect!" width="854" />
    </a>
</p>

<p align="center">
    <a href="https://github.com/PerfectlySoft/Perfect" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg" alt="Star Perfect On Github" />
    </a>  
    <a href="http://stackoverflow.com/questions/tagged/perfect" target="_blank">
        <img src="http://www.perfect.org/github/perfect_gh_button_2_SO.jpg" alt="Stack Overflow" />
    </a>  
    <a href="https://twitter.com/perfectlysoft" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg" alt="Follow Perfect on Twitter" />
    </a>  
    <a href="http://perfect.ly" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg" alt="Join the Perfect Slack" />
    </a>
</p>

<p align="center">
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat" alt="Swift 4.0">
    </a>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms OS X | Linux">
    </a>
    <a href="http://perfect.org/licensing.html" target="_blank">
        <img src="https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat" alt="License Apache">
    </a>
    <a href="http://twitter.com/PerfectlySoft" target="_blank">
        <img src="https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat" alt="PerfectlySoft Twitter">
    </a>
    <a href="http://perfect.ly" target="_blank">
        <img src="http://perfect.ly/badge.svg" alt="Slack Status">
    </a>
</p>

**NOTE** This is not an official product of Perfect. However, Squishy is an independent parser library which can translate a "squishy" file into a Perfect Swift handler.

A squishy file looks like this - yes, it is a Swift-style hyper text preprocessor:

``` php
<%
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

func add(a: Int, b: Int) -> {
  return a + b
}
%>
<HTML><HEAD><META CHARSET="UTF-8">
<TITLE>测试脚本</TITLE>
</HEAD><BODY>
<?
  let x = UUID()
  let y = "\(x)"
  response.setHeader(.contentType, value: "text/html")
?>
<H1>你好！ \(y) 和 \(add(a: 1, b: 2))</H1>
</BODY></HTML>
```

and the outcome of translation would look like:

``` swift

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

func add(a: Int, b: Int) -> {
  return a + b
}


func handlerX(data: [String:Any]) throws -> RequestHandler { return {
  request, response in
  
	response.appendBody(string: 
"""

<HTML><HEAD><META CHARSET=\"UTF-8\">
<TITLE>测试脚本</TITLE>
</HEAD><BODY>

"""
)

  let x = UUID()
  let y = "\(x)"
  response.setHeader(.contentType, value: "text/html")

	response.appendBody(string: 
"""

<H1>你好！ \(y) 和 \(add(a: 1, b: 2))</H1>
</BODY></HTML>
"""
)

  response.completed()
  }
}
```

# Quick Start

## Squishy Syntax

A Squishy web page can have three different types of scripts natively:

- **HTML**. This is the default format.
- **Global Swift Code**. Content marked inside `<% ... %>` will be translated into a swift program in the current name space.
- **Perfect Route Handler**. Content that marked with `<? ... ?>` will be treated as a standard named *Perfect Route Handler*, where the two key variables `request: HTTPRequest` and `response: HTTPResponse` are available in this section.

## Prerequisites

Swift 4.0 toolchain.

## Package.swift

```
.package(url: "https://github.com/RockfordWei/Perfect-Squishy.git", 
from: "1.0.1")

...
dependencies: ["PerfectSquishy"]
```

## Usage

The following snippet can translate the above "x.squishy" file into "y.swift":

``` swift
import PerfectSquishy

let from = "x.squishy"
let to = "y.swift"
let parser = Squishy(handler: "handlerX", from: from, to: to)
try parser.parse()
```

## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).


## Now WeChat Subscription is Available (Chinese)
<p align=center><img src="https://raw.githubusercontent.com/PerfectExamples/Perfect-Cloudinary-ImageUploader-Demo/master/qr.png"></p>
