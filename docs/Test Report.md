# Test Report

## Pipeline Execution

### Dev

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image.png)

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%201.png)

---

### Unit Tests

Estructura (buenas practicas)

Structured according to best practices

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%202.png)

```java
    @Test
    void testFindById_ShouldReturnCategoryDto() {
        when(categoryRepository.findById(1)).thenReturn(Optional.of(CategoryUtil.getSampleCategory()));

        CategoryDto result = categoryService.findById(category.getCategoryId());

        assertNotNull(result);
        assertEquals(category.getCategoryId(), result.getCategoryId());
        assertEquals(category.getCategoryTitle(), result.getCategoryTitle());
        assertEquals(category.getImageUrl(), result.getImageUrl());
    }
```

---

### stage

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%203.png)

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%204.png)

---

### Integration Tests

```java
    @Test
    public void testFindAllCategories() {
        String url = "http://localhost:" + port + "/product-service/api/categories";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        ResponseEntity<String> response = restTemplate.exchange(
                url,
                HttpMethod.GET,
                new HttpEntity<>(headers),
                String.class
        );

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
    }
```

---

### End-to-End (E2E) Tests:

1. Implemented with TestContainers to simulate realistic environments
    
    ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%205.png)
    
2. SetUp testContainers
    
    ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%206.png)
    

---

### Load and Stress Tests with Locust

1. Creacion de pruebas por endpoints o host a probar
    
    ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%207.png)
    
2. Docker containers for testing that self-remove after execution
    
    ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%208.png)
    
3. HTML reports generated and published using Jenkins `publishHtml` plugin
    
    ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%209.png)
    

---

## Tests and Results

### Unit

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2010.png)

### Integration

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2011.png)

### End-to-End (E2E)

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2012.png)

### Locust

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2013.png)

1. Payment
    1. Load
        
        ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2014.png)
        
    2. Stress
        
        ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2015.png)
        
2. Order
    1. Load
        
        ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2016.png)
        
    2. Stress
        
        ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2017.png)
        
3. Favourite
    1. Load
        
        ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2018.png)
        
    2. Stress
        
        ![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2019.png)
        

---

## Analysis, Interpretation & Conclusions

Load test

### Payment

The payment service was evaluated through three endpoints, showing mixed behavior.

The POST and GET by ID operations had excellent response times (9.75 ms and 14.46 ms respectively), with very low maximum values and no errors, demonstrating agile performance in creation and individual query tasks.

However, the GET endpoint `/api/payments` showed a higher average latency (109.15 ms) and a 99th percentile of up to 360 ms, likely due to the larger response size.

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2020.png)

### Order

This service had the best overall performance among those evaluated.

With an average response time of only 13.76 ms and a 95th percentile of 19 ms, the endpoint proved to be highly efficient even under a load of 287 requests.

No errors were recorded, and the throughput reached a solid 4.85 RPS.

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2021.png)

### Favourite

The favorites service showed stable and efficient behavior during the load test, with an average response time of 47.29 ms and a throughput of 4.72 requests per second.

No errors were recorded, indicating high reliability under moderate load.

Although most responses were fast (95th percentile at 73 ms), an outlier was observed with a maximum response time of 935 ms, suggesting there might be a specific condition slowing down the processing.

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2022.png)

---

Stress test

### Payment

During the stress test, the payments service was the most impacted by the load, especially the GET /api/payments endpoint, which showed an average response time of 193.7 ms and a maximum of 1228 ms, with a 99th percentile of 1200 ms.

This suggests that the payment listing operation is not fully optimized for high loads, possibly due to the amount of data returned or lack of efficient pagination.

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2023.png)

### Order

The orders service demonstrated outstanding resilience under stress, processing 1,397 requests in one minute without any failures and maintaining an average response time of only 5.16 ms.

Even under high concurrency conditions, the maximum recorded time was just 42 ms, with a 99th percentile of 16 ms, which is remarkably low.

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2024.png)

### Favourite

Under stress conditions, the favorites service also behaved robustly, handling 1,394 requests in one minute with an average response time of 18.75 ms.

Although this time is higher than that observed in the orders service, it remains quite acceptable. The 95th percentile was 37 ms, while the 99th percentile reached 63 ms and the maximum value was 190 ms, indicating slight variability under high load.

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2025.png)

---

## JaCoCo

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2026.png)

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2027.png)

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2028.png)

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2029.png)

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2030.png)

---

## Sonarqube

![image.png](Test%20Report%202043367fc8f4803c8c9dca66375bc614/image%2031.png)

The SonarQube dashboard provides a mixed but insightful overview of the 12 projects in the ecosystem. On a positive note, the static analysis did not detect any high-severity security vulnerabilities or reliability bugs (all projects are rated 'A').