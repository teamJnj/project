package com.icia.jnj.test;

public class starTest {
	
	public static void main(String[] args) {
		String star="";
		for(int i=0; i<5; i++){
			if( i < 6 )	star += "★";
			else					star += "☆";
		}
		
		System.err.println(star);
	}

}
