package com.icia.jnj.controller;

import java.sql.*;
import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.validation.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.*;

import com.google.gson.*;

import lombok.extern.slf4j.*;

@ControllerAdvice
@Slf4j
public class ErrorController {
	@Autowired
	private Gson gson;
	@ExceptionHandler(SQLException.class)
	public ModelAndView sqlExceptionHandler(SQLException se) {
		log.info("SQLException 발생");
		ModelAndView mav = new ModelAndView("exception/exceptionMsg");
		return mav.addObject("msg", se.getMessage());
	}
	@ExceptionHandler(SQLSyntaxErrorException.class)
	public ModelAndView sqlSyntaxErrorExceptionHandler(SQLSyntaxErrorException se) {
		log.info("SQL문법오류 발생");
		ModelAndView mav = new ModelAndView("exception/exceptionMsg");
		return mav.addObject("msg", se.getMessage());
	}
	//@ExceptionHandler(BindException.class)
	public ModelAndView bindExceptionHandler(BindException be) {
		log.info("BindException 발생");
		ModelAndView mav = new ModelAndView("exception/exceptionMsgs");
		List<ObjectError> list =  be.getAllErrors();
		List<String> msgs = new ArrayList<String>(); 
		for(ObjectError oe : list) { 
			FieldError fe = (FieldError)oe;
			msgs.add(fe.getField() + ":" +  oe.getDefaultMessage());
		}
		return mav.addObject("msgs", gson.toJson(msgs));
	}
}
