# test
### Workflow
```flow
st=>start: Start
e=>end
op=>operation: commit
bu=>operation: build
cond=>condition: deploy REF?
de=>operation: deploy

st->op->bu->cond->de
cond(yes)->de->e
cond(no)->e
```
