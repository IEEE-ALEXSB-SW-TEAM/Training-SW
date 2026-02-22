-- Drop in dependency order
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS book_copies;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS branches;

-- =========================================================
-- 1) branches
-- =========================================================
CREATE TABLE branches (
  branch_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name      VARCHAR(150)    NOT NULL,
  address   VARCHAR(255)    NOT NULL,
  phone     VARCHAR(30)     NULL,

  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (branch_id),
  UNIQUE KEY uq_branches_name (name),
  KEY idx_branches_city_search (address)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =========================================================
-- 2) employees
-- =========================================================
CREATE TABLE employees (
  employee_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  branch_id   BIGINT UNSIGNED NOT NULL,

  full_name   VARCHAR(150)    NOT NULL,
  role        VARCHAR(80)     NOT NULL,
  hire_date   DATE            NOT NULL,
  email       VARCHAR(254)    NULL,
  phone       VARCHAR(30)     NULL,

  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (employee_id),

  -- Constraints
  CONSTRAINT fk_employees_branch
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  UNIQUE KEY uq_employees_email (email),
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =========================================================
-- 3) members
-- =========================================================
CREATE TABLE members (
  member_id  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  full_name  VARCHAR(150)    NOT NULL,
  email      VARCHAR(254)    NOT NULL,
  phone      VARCHAR(30)     NULL,

  join_date  DATE            NOT NULL DEFAULT (CURRENT_DATE),
  status     ENUM('active','suspended') NOT NULL DEFAULT 'active',

  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (member_id),

  -- Constraints
  UNIQUE KEY uq_members_email (email),

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =========================================================
-- 4) books
-- =========================================================
CREATE TABLE books (
  book_id      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  isbn         VARCHAR(20)      NOT NULL,
  title        VARCHAR(255)     NOT NULL,
  author       VARCHAR(255)     NOT NULL,
  publisher    VARCHAR(255)     NULL,
  publish_year SMALLINT UNSIGNED NULL,
  category     VARCHAR(120)     NULL,

  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (book_id),

  -- Constraints
  UNIQUE KEY uq_books_isbn (isbn),

  -- Guardrails
  CONSTRAINT chk_books_publish_year
    CHECK (publish_year IS NULL OR (publish_year >= 1400 AND publish_year <= YEAR(CURRENT_DATE)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =========================================================
-- 5) book_copies (physical items across branches)
-- =========================================================
CREATE TABLE book_copies (
  copy_id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  book_id        BIGINT UNSIGNED NOT NULL,
  branch_id      BIGINT UNSIGNED NOT NULL,

  barcode        VARCHAR(64)     NOT NULL,
  status         ENUM('available','loaned','lost','maintenance')
                NOT NULL DEFAULT 'available',
  condition_note VARCHAR(255)    NULL,

  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (copy_id),

  -- Constraints
  CONSTRAINT fk_book_copies_book
    FOREIGN KEY (book_id) REFERENCES books(book_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_book_copies_branch
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  UNIQUE KEY uq_book_copies_barcode (barcode),

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =========================================================
-- 6) loans (borrowing transactions)
-- Notes:
-- - returned_at NULL means "still borrowed"
-- - issued_by_employee_id and return_received_by_employee_id must belong to employees
-- =========================================================
CREATE TABLE loans (
  loan_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

  copy_id   BIGINT UNSIGNED NOT NULL,
  member_id BIGINT UNSIGNED NOT NULL,

  issued_by_employee_id BIGINT UNSIGNED NOT NULL,
  return_received_by_employee_id BIGINT UNSIGNED NULL,

  borrowed_at DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  due_at      DATETIME(0) NOT NULL,
  returned_at DATETIME(0) NULL,

  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (loan_id),

  -- Constraints
  CONSTRAINT fk_loans_copy
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_loans_member
    FOREIGN KEY (member_id) REFERENCES members(member_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_loans_issued_by
    FOREIGN KEY (issued_by_employee_id) REFERENCES employees(employee_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_loans_return_received_by
    FOREIGN KEY (return_received_by_employee_id) REFERENCES employees(employee_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Guardrails
  CONSTRAINT chk_loans_dates
    CHECK (
      due_at > borrowed_at
      AND (returned_at IS NULL OR returned_at >= borrowed_at)
    ),

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

