#include <assert.h>
#include <stdio.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything" // cSpell: disable-line
#include <yyjson.h>
#pragma clang diagnostic pop

int main() {
    yyjson_read_err err;
    yyjson_doc *doc = yyjson_read_file("examples/entrypoint/jello.json", 0, nullptr, &err);
    assert(doc);

    yyjson_val *root = yyjson_doc_get_root(doc);
    yyjson_val *compilerTests = yyjson_obj_get(root, "compilerTests");
    size_t idx;
    size_t max;
    yyjson_val *compilerTest;
    yyjson_arr_foreach(compilerTests, idx, max, compilerTest) {
        printf("compiler test #%zu: args: [", idx);

        yyjson_val *args = yyjson_obj_get(compilerTest, "args");
        size_t idxArgs;
        size_t maxArgs;
        yyjson_val *arg;
        yyjson_arr_foreach(args, idxArgs, maxArgs, arg) {
            printf("%s%s", idxArgs ? ", " : "", yyjson_get_str(arg));
        }

        printf("]\n");
    }

    yyjson_doc_free(doc);
}
