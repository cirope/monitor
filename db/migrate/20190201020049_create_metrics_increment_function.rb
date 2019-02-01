class CreateMetricsIncrementFunction < ActiveRecord::Migration[5.2]
  def up
    execute %Q[
          CREATE FUNCTION metrics_increment(_table regclass, user_id varchar, amount decimal) RETURNS int AS $$

          DECLARE
          exist int;
          result int;

          BEGIN
            EXECUTE format('SELECT 1 FROM %I WHERE date=current_date AND user_id=$1 LIMIT 1', _table)
              INTO exist
              USING user_id;

            IF exist > 0 THEN
              EXECUTE format('UPDATE %I SET count=count+$2, amount=amount+$3 WHERE date=current_date AND user_id=$1 RETURNING count', _table)
                INTO result
                USING user_id, 1, amount;
            ELSE
              EXECUTE format('INSERT INTO %I (date, user_id, count, amount) VALUES (current_date, $1, $2, $3) RETURNING count', _table)
                INTO result
                USING user_id, 1, amount;
            END IF;

            RETURN result;
          END;
          $$ LANGUAGE plpgsql;
        ]
  end

  def down
    execute 'DROP FUNCTION metrics_increment;'
  end
end
