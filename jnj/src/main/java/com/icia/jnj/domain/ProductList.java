package com.icia.jnj.domain;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductList {
	List<BasketProduct> productList = new ArrayList<BasketProduct>();
}  
