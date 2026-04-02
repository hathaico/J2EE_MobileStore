package com.mobilestore.service;

import com.mobilestore.dao.BrandDAO;
import com.mobilestore.model.Brand;

import java.sql.SQLException;
import java.util.List;

public class BrandService {
    private final BrandDAO brandDAO;
    public BrandService(){ this.brandDAO = new BrandDAO(); }

    public List<Brand> getAllBrands(){ return brandDAO.getAllBrands(); }

    public boolean createBrand(Brand b) throws SQLException { return brandDAO.createBrand(b); }

    public Brand findByName(String name){ return brandDAO.findByName(name); }
}
