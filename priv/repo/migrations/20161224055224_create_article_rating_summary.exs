defmodule BenarID.Repo.Migrations.CreateArticleRatingSummary do
  @moduledoc """
  Adds a `article_rating_summary` table for querying stats.

  This also create triggers for updating the table on insertion
  to article_ratings table.
  """

  use Ecto.Migration

  def up do
    create table(:article_rating_summary) do
      add :article_id, references(:articles)
      add :rating_id, references(:ratings)
      add :sum, :integer
      add :count, :integer
    end

    create unique_index(:article_rating_summary, [:article_id, :rating_id])

    # Creates a function that Updates the entry for article_rating_summary.
    # This handles INSERT, UPDATE, or DELETE query on article_ratings table.
    execute """
    CREATE OR REPLACE FUNCTION update_rating_summary()
    RETURNS trigger AS $$
    BEGIN

      IF (TG_OP = 'INSERT') THEN

        -- INSERT, we perform an upsert
        INSERT INTO article_rating_summary AS ARS (article_id, rating_id, sum, count)
          VALUES
            (NEW.article_id, NEW.rating_id, NEW.value, 1)
          ON CONFLICT
            (article_id, rating_id)
          DO UPDATE SET
            (sum, count) = (ARS.sum + NEW.value, ARS.count + 1);

      ELSIF (TG_OP = 'UPDATE') THEN

        -- UPDATE, we subtract the sum with (old - new)
        UPDATE article_rating_summary AS ARS
          SET
            sum = ARS.sum - (OLD.value - NEW.value)
          WHERE article_id = NEW.article_id
            AND rating_id = NEW.rating_id;

      ELSIF (TG_OP = 'DELETE') THEN

        -- DELETE, we subtract the row
        UPDATE article_rating_summary AS ARS
        SET
          (sum, count) = (ARS.sum - OLD.value, ARS.count - 1)
        WHERE ARS.article_id = OLD.article_id
          AND ARS.rating_id = OLD.rating_id;

      END IF;

      RETURN NULL; -- return value is ignored for AFTER triggers.
    END
    $$ LANGUAGE plpgsql
    """

    # Creates a trigger that calls update_rating_summary
    execute """
    CREATE TRIGGER update_rating_summary_trg
      AFTER INSERT OR UPDATE OR DELETE ON article_ratings
      FOR EACH ROW
      EXECUTE PROCEDURE update_rating_summary()
    """
  end

  def down do
    execute "DROP TRIGGER IF EXISTS update_rating_summary_trg ON article_ratings"
    execute "DROP FUNCTION IF EXISTS update_rating_summary()"
    drop unique_index(:article_rating_summary, [:article_id, :rating_id])
    drop table(:article_rating_summary)
  end
end
