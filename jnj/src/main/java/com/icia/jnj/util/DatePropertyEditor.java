package com.icia.jnj.util;

import java.beans.*;

public class DatePropertyEditor extends PropertyEditorSupport {
	@Override // 객체로
    public void setAsText(String text) {
		String str = text.replace("-", "");
		setValue(str);
    }
}
