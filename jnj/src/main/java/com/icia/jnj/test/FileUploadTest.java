package com.icia.jnj.test;

import java.io.*;

import org.springframework.stereotype.*;
import org.springframework.util.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;

@Controller
public class FileUploadTest {

	
	@GetMapping("/file_upload")
	public String FileUpload( ) {
		return "test/fileTest";
	}
	
	@PostMapping("/file_upload")
	public String FileUpload( MultipartFile[] files ) {
		
		int idx =0;
		for( MultipartFile file:files ) {
			
			if( file.getOriginalFilename().equals("") )
				break;
			
			System.err.println( "file["+idx+"]" + (file.getOriginalFilename()) );
			String savedFileName = System.currentTimeMillis() + "-" + file.getOriginalFilename();
			System.err.println( "savedFileName["+idx+"]" + savedFileName );
		}
		
		
		return "test/fileTest";
	}
	
}
