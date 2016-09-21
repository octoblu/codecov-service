# codecov-service

[![Build Status](https://travis-ci.org/octoblu/codecov-service.svg?branch=master)](https://travis-ci.org/octoblu/codecov-service)
[![Test Coverage](https://codecov.io/gh/octoblu/codecov-service/branch/master/graph/badge.svg)](https://codecov.io/gh/octoblu/codecov-service)
[![Dependency status](http://img.shields.io/david/octoblu/codecov-service.svg?style=flat)](https://david-dm.org/octoblu/codecov-service)
[![devDependency Status](http://img.shields.io/david/dev/octoblu/codecov-service.svg?style=flat)](https://david-dm.org/octoblu/codecov-service#info=devDependencies)
[![Slack Status](http://community-slack.octoblu.com/badge.svg)](http://community-slack.octoblu.com)

# Table of Contents

* [Introduction](#introduction)
* [Getting Started](#getting-started)
  * [Install](#install)
* [Usage](#usage)
  * [Default](#default)
  * [Docker](#docker)
    * [Development](#development)
    * [Production](#production)
  * [Debugging](#debugging)
  * [Test](#test)
* [License](#license)

# Introduction

...

# Getting Started

## Install

```bash
git clone https://github.com/octoblu/codecov-service.git
cd /path/to/codecov-service
npm install
```

# Usage

## Default

```javascript
node command.js
```

## Docker

### Development

```bash
docker build -t local/codecov-service .
docker run --rm -it --name codecov-service-local -p 8888:80 local/codecov-service
```

### Production

```bash
docker pull quay.io/octoblu/codecov-service
docker run --rm -p 8888:80 quay.io/octoblu/codecov-service
```

## Debugging

```bash
env DEBUG='codecov-service*' node command.js
```

```bash
env DEBUG='codecov-service*' node command.js
```

## Test

```bash
npm test
```

## License

The MIT License (MIT)

Copyright (c) 2016 Octoblu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
