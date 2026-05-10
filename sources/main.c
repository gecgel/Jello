#include <assert.h>
#include <stdio.h>
#include <yyjson.h>

int main() {
  yyjson_read_err err;
  yyjson_doc *doc =
      yyjson_read_file("examples/entrypoint/jello.json", 0, NULL, &err);
  assert(doc);

  yyjson_val *root = yyjson_doc_get_root(doc);
  yyjson_val *compilerTests = yyjson_obj_get(root, "compilerTests");
  size_t idx, max;
  yyjson_val *compilerTest;
  yyjson_arr_foreach(compilerTests, idx, max, compilerTest) {
    printf("compiler test #%zu: args: [", idx);

    yyjson_val *args = yyjson_obj_get(compilerTest, "args");
    size_t idxArgs, maxArgs;
    yyjson_val *arg;
    yyjson_arr_foreach(args, idxArgs, maxArgs, arg) {
      printf("%s%s", idxArgs ? ", " : "", yyjson_get_str(arg));
    }

    printf("]\n");
  }

  yyjson_doc_free(doc);
}
