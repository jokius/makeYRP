#!/usr/bin/env sh

rm -rf public/packs
rm -rf public/assets
RAILS_ENV=production rails assets:precompile
tar -zcvf packs.tar public/packs
scp -r public/assets deploy@makeyrp.ru:/home/deploy/app/shared/public/
scp packs.tar deploy@makeyrp.ru:/home/deploy/app/shared/
ssh deploy@makeyrp.ru 'cd /home/deploy/app/shared/ && tar -xvf packs.tar && rm packs.tar'
rm packs.tar
rm -rf public/packs
yarn
