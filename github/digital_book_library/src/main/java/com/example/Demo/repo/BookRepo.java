package com.example.Demo.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.Demo.entity.Book;
public interface BookRepo extends JpaRepository<Book,String>{
	
}