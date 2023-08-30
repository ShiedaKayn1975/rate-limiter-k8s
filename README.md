# README

``` yaml
# YAML
rate_limit_rules:
  - domain: client
    resources:
      - name: products
        actions:
          - action: index
            descriptors:
              key: ip_address
              rate_limit:
                unit: minutes
                request_per_unit: 5
          - action: create
            descriptors:
              key: ip_address
              rate_limit:
                unit: hours
                request_per_unit: 10
```
