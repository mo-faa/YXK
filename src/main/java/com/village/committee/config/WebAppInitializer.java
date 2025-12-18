package com.village.committee.config;

import com.village.committee.web.filter.CsrfTokenFilter;
import com.village.committee.web.filter.RequestIdFilter;
import jakarta.servlet.Filter;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class<?>[]{RootConfig.class};
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[]{WebMvcConfig.class};
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }

    @Override
    protected Filter[] getServletFilters() {
        CharacterEncodingFilter encoding = new CharacterEncodingFilter();
        encoding.setEncoding("UTF-8");
        encoding.setForceEncoding(true);

        return new Filter[]{
                encoding,
                new RequestIdFilter(),
                new CsrfTokenFilter()
        };
    }
}
