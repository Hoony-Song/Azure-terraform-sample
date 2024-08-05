{
  "name": "test-route",
  "protocols": [
    "http",
    "https"
  ],
  "methods": [
    "GET",
    "POST"
  ],
  "hosts": [
    "example.com",
    "foo.test"
  ],
  "paths": [
    "/foo",
    "/bar"
  ],
  "headers": {
    "x-my-header": [
      "foo",
      "bar"
    ],
    "x-another-header": [
      "bla"
    ]
  },
  "service": {
    "id": "${service_id}"
  }
}
