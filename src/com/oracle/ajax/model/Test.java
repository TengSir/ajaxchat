package com.oracle.ajax.model;

import java.io.File;
import java.util.regex.Pattern;

public class Test {
	public static void main(String[] args) {
		File  f=new File("C:/Users/TengSir/Desktop/lrc");
		String[] path=f.list();
		for (String p:path) {
			File s=new File(f,p);
			if(s.isFile())
			{
				Pattern  pp=Pattern.compile("-[0-9|a-z]{1,}");
				String name=s.getName();
				System.out.println(pp.matcher(name).replaceAll(""));;
				s.renameTo(new File("D:\\"+pp.matcher(name).replaceAll("")));
//				System.out.println(s.getName());
			}
		}
	}

}
