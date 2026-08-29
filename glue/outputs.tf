output "catalog_database_name" {
  description = "Name of the Glue Catalog database"
  value       = aws_glue_catalog_database.cob_catalog_db.name
}


