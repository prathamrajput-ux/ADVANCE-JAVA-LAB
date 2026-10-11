package com.shopsphere.filter;

import com.shopsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && user.isAdmin()) {
            // Authorized administrator: grant access
            chain.doFilter(request, response);
        } else if (user != null) {
            // Logged in as standard customer: access forbidden
            session.setAttribute("flashError", "Access Denied: Administrator privileges required.");
            res.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            // Unauthenticated: redirect to login
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("redirectAfterLogin", req.getRequestURI());
            newSession.setAttribute("flashError", "Please sign in with administrator credentials.");
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}
