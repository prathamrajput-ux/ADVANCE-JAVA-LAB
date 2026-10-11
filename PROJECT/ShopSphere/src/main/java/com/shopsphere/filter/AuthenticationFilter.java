package com.shopsphere.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/checkout", "/orders"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            // User is authenticated, proceed along the filter chain
            chain.doFilter(request, response);
        } else {
            // Unauthenticated: store target URI for redirect post-login
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("redirectAfterLogin", req.getRequestURI());
            newSession.setAttribute("flashError", "Please sign in to access this page.");
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}
