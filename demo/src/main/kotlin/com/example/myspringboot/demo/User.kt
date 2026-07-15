package com.example.myspringboot.demo

import jakarta.persistence.*
import com.fasterxml.jackson.annotation.JsonIgnoreProperties

@Entity
@Table(name = "users")
@JsonIgnoreProperties(ignoreUnknown = true)
class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    var name: String = ""

    var email: String = ""

    constructor()

    constructor(name: String, email: String) {
        this.name = name
        this.email = email
    }
}